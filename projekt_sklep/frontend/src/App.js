import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
    const [products, setProducts] = useState([]);
    const [categories, setCategories] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState('');
    const [sortOrder, setSortOrder] = useState('asc');
    const [newProduct, setNewProduct] = useState({ name: '', price: '', category: '' });
    const [newCategory, setNewCategory] = useState('');

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = () => {
        axios.get('http://localhost:5000/products')
            .then(response => setProducts(response.data))
            .catch(error => console.error('Błąd pobierania produktów:', error));

        axios.get('http://localhost:5000/categories')
            .then(response => setCategories(response.data))
            .catch(error => console.error('Błąd pobierania kategorii:', error));
    };

    const handleAddProduct = () => {
        axios.post('http://localhost:5000/products', newProduct)
            .then(response => {
                setProducts(response.data);
                setNewProduct({ name: '', price: '', category: '' });
            })
            .catch(error => console.error('Błąd dodawania produktu:', error));
    };

    const handleAddCategory = () => {
        if (!newCategory.trim()) return;
        axios.post('http://localhost:5000/categories', { name: newCategory })
            .then(() => {
                fetchData();
                setNewCategory('');
            })
            .catch(error => console.error('Błąd dodawania kategorii:', error));
    };

    const handleDeleteProduct = (id) => {
        axios.delete(`http://localhost:5000/products/${id}`)
            .then(() => fetchData())
            .catch(error => console.error('Błąd usuwania produktu:', error));
    };

    const handleDeleteCategory = (id) => {
        axios.delete(`http://localhost:5000/categories/${id}`)
            .then(() => fetchData())
            .catch(error => console.error('Błąd usuwania kategorii:', error));
    };

    const filteredProducts = products
        .filter(product => !selectedCategory || product.category === selectedCategory)
        .sort((a, b) => sortOrder === 'asc' ? a.price - b.price : b.price - a.price);

    return (
        <div className="container">
            <h1 className="title">Lista produktów</h1>

            {/* Sekcja z produktami */}
            <div className="product-list">
                <h2>Aktualne produkty</h2>
                {filteredProducts.length === 0 ? (
                    <p>Brak produktów{selectedCategory && ` w kategorii ${selectedCategory}`}</p>
                ) : (
                    <table>
                        <thead>
                            <tr>
                                <th>Nazwa</th>
                                <th onClick={() => setSortOrder(prev => prev === 'asc' ? 'desc' : 'asc')}>
                                    Cena {sortOrder === 'asc' ? '↑' : '↓'}
                                </th>
                                <th>Kategoria</th>
                                <th>Akcje</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filteredProducts.map(product => (
                                <tr key={product._id}>
                                    <td>{product.name}</td>
                                    <td>{Number(product.price).toFixed(2)} zł</td>
                                    <td>{product.category}</td>
                                    <td>
                                        <button
                                            onClick={() => handleDeleteProduct(product._id)}
                                            className="delete-btn"
                                        >
                                            🗑
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>

            <div className="filters">
                <label>Kategoria:
                    <select
                        value={selectedCategory}
                        onChange={(e) => setSelectedCategory(e.target.value)}
                    >
                        <option value="">Wszystkie</option>
                        {categories.map(category => (
                            <option key={category._id} value={category.name}>{category.name}</option>
                        ))}
                    </select>
                </label>
                <label>Sortowanie po cenie:
                    <select
                        value={sortOrder}
                        onChange={(e) => setSortOrder(e.target.value)}
                    >
                        <option value="asc">Rosnąco</option>
                        <option value="desc">Malejąco</option>
                    </select>
                </label>
            </div>

            <div className="form">
                <h2>Dodaj produkt</h2>
                <input
                    type="text"
                    placeholder="Nazwa"
                    value={newProduct.name}
                    onChange={(e) => setNewProduct({...newProduct, name: e.target.value})}
                />
                <input
                    type="number"
                    placeholder="Cena"
                    value={newProduct.price}
                    onChange={(e) => setNewProduct({...newProduct, price: e.target.value})}
                />
                <select
                    value={newProduct.category}
                    onChange={(e) => setNewProduct({...newProduct, category: e.target.value})}
                >
                    <option value="">Wybierz kategorię</option>
                    {categories.map(category => (
                        <option key={category._id} value={category.name}>{category.name}</option>
                    ))}
                </select>
                <button
                    onClick={handleAddProduct}
                    disabled={categories.length === 0}
                    className={categories.length === 0 ? "disabled" : ""}
                >
                    Dodaj produkt
                </button>
                {categories.length === 0 && <p className="error">Najpierw dodaj kategorię!</p>}
            </div>

            <div className="form">
                <h2>Dodaj kategorię</h2>
                <input
                    type="text"
                    placeholder="Nazwa kategorii"
                    value={newCategory}
                    onChange={(e) => setNewCategory(e.target.value)}
                />
                <button
                    onClick={handleAddCategory}
                    disabled={!newCategory.trim()}
                    className={!newCategory.trim() ? "disabled" : ""}
                >
                    Dodaj kategorię
                </button>

                <h3>Istniejące kategorie:</h3>
                {categories.length === 0 ? (
                    <p>Brak kategorii</p>
                ) : (
                    <ul>
                        {categories.map(category => (
                            <li key={category._id} className="category-item">
                                {category.name}
                                <button
                                    onClick={() => handleDeleteCategory(category._id)}
                                    className="delete-btn"
                                >
                                    🗑
                                </button>
                            </li>
                        ))}
                    </ul>
                )}
            </div>
        </div>
    );
}

export default App;