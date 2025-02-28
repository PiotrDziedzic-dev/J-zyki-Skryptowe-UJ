import os
import certifi

os.environ["SSL_CERT_FILE"] = certifi.where()

import discord
import yaml
import json
from datetime import datetime, timedelta
from difflib import get_close_matches
from discord.ext import commands

with open("config.yml", "r") as f:
    config = yaml.safe_load(f)

with open("intents/patterns.json", "r") as f:
    intents_data = json.load(f)

intents = discord.Intents.default()
intents.messages = True
intents.message_content = True  # Wymaga włączenia w Developer Portal
intents.members = True  # Wymaga włączenia w Developer Portal
intents.presences = True  # Wymaga włączenia w Developer Portal

bot = commands.Bot(
    command_prefix="!",
    intents=intents
)

user_states = {}
orders = {}
delivery_addresses = {}

class UserState:
    def __init__(self):
        self.ordering = False
        self.awaiting_address = False

def get_intent(user_input):
    user_input = user_input.lower()
    for intent in intents_data["intents"]:
        for pattern in intent["patterns"]:
            if get_close_matches(user_input, [pattern], n=1, cutoff=0.7):
                return intent
    return None

@bot.event
async def on_ready():
    print(f"Zalogowano jako {bot.user}!")

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return

    user_id = message.author.id
    if user_id not in user_states:
        user_states[user_id] = UserState()

    state = user_states[user_id]
    content = message.content.lower()

    if state.ordering:
        if "confirm" in content:
            total = sum(config["menu"][item]["price"] * qty for item, qty in orders[user_id].items())
            await message.channel.send(f"Order confirmed! Total: ${total:.2f}")

            if user_id in delivery_addresses:
                await message.channel.send(f"Delivery expected in 45 minutes to {delivery_addresses[user_id]}")
            else:
                pickup_time = (datetime.now() + timedelta(minutes=30)).strftime("%H:%M")
                await message.channel.send(f"Your order will be ready for pickup at {pickup_time}.")

            state.ordering = False
            orders.pop(user_id, None)
            delivery_addresses.pop(user_id, None)
        elif state.awaiting_address:
            delivery_addresses[user_id] = message.content
            state.awaiting_address = False
            await message.channel.send(f"Delivery address set to: {message.content}")
        elif "delivery" in content:
            state.awaiting_address = True
            await message.channel.send("Please enter your delivery address:")
        elif "pickup" in content:
            await message.channel.send("Please list the items you'd like to order (e.g., '2x pizza, 1x burger').")
        else:
            found = False
            for item in config["menu"]:
                if item in content:
                    qty = 1
                    if "x" in content:
                        try:
                            qty = int(content.split("x")[1].strip())
                        except:
                            pass
                    if user_id not in orders:
                        orders[user_id] = {}
                    orders[user_id][item] = qty
                    found = True
                    break
            if not found:
                await message.channel.send("Item not found. Please choose from the menu.")
            return

    intent = get_intent(message.content)
    if intent:
        tag = intent["tag"]
        if tag == "greeting":
            await message.channel.send("Hello! How can I help you today?")
        elif tag == "opening_hours":
            hours = "\n".join([f"{day}: {time}" for day, time in config["opening_hours"].items()])
            await message.channel.send(f"Our opening hours:\n{hours}")
        elif tag == "menu":
            menu = "\n".join([f"{item}: ${details['price']} ({details['description']})" for item, details in config["menu"].items()])
            await message.channel.send(f"Menu:\n{menu}")
        elif tag == "order":
            orders[user_id] = {}
            state.ordering = True
            await message.channel.send("Would you like pickup or delivery?")

bot.run("API_KEY")