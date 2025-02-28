// Backend (NodeJS + Express)
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Połączenie z MongoDB
mongoose.connect('mongodb://localhost:5001/sklep', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).catch(error => console.error('Błąd połączenia z MongoDB:', error));

// Modele
const Product = mongoose.model('Product', new mongoose.Schema({
    name: String,
    price: Number,
    category: String,
}));

const Category = mongoose.model('Category', new mongoose.Schema({
    name: String,
}));

// Middleware do logowania błędów
app.use((err, req, res, next) => {
    console.error('Błąd serwera:', err);
    res.status(500).json({ error: 'Wewnętrzny błąd serwera' });
});

// Endpointy API
app.get('/products', async (req, res, next) => {
    try {
        const products = await Product.find();
        res.json(products);
    } catch (error) {
        next(error);
    }
});

app.post('/products', async (req, res, next) => {
    try {
        const product = new Product(req.body);
        await product.save();
        const products = await Product.find(); // Pobranie zaktualizowanej listy produktów
        res.json(products);
    } catch (error) {
        next(error);
    }
});

app.delete('/products/:id', async (req, res, next) => {
    try {
        await Product.findByIdAndDelete(req.params.id);
        const products = await Product.find();
        res.json(products);
    } catch (error) {
        next(error);
    }
});

app.get('/categories', async (req, res, next) => {
    try {
        const categories = await Category.find();
        res.json(categories);
    } catch (error) {
        next(error);
    }
});

app.post('/categories', async (req, res, next) => {
    try {
        const category = new Category(req.body);
        await category.save();
        const categories = await Category.find(); // Pobranie zaktualizowanej listy kategorii
        res.json(categories);
    } catch (error) {
        next(error);
    }
});

app.delete('/categories/:id', async (req, res, next) => {
    try {
        await Category.findByIdAndDelete(req.params.id);
        const categories = await Category.find();
        res.json(categories);
    } catch (error) {
        next(error);
    }
});

app.listen(5000, () => console.log('Server działa na porcie 5000'));