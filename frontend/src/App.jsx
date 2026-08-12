import { useEffect, useState } from "react";
import axios from "axios";
import "./App.css";

const API_URL =
  import.meta.env.VITE_API_URL ||
  "http://localhost:3000";

function App() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await axios.get(`${API_URL}/api/products`);
        setProducts(response.data);
      } catch (err) {
        console.error("Failed to fetch products:", err);
        setError("Unable to load products. Please try again later.");
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  return (
    <div className="app">
      <header className="navbar">
        <div className="logo">ShopNest</div>

        <nav>
          <a href="#home">Home</a>
          <a href="#products">Products</a>
          <a href="#about">About</a>
          <button className="cart-button">Cart (0)</button>
        </nav>
      </header>

      <main>
        <section className="hero" id="home">
          <div>
            <p className="hero-label">WELCOME TO SHOPNEST</p>

            <h1>
              Everything you need,
              <br />
              in one place.
            </h1>

            <p className="hero-description">
              Discover quality products at great prices with a simple,
              secure shopping experience.
            </p>

            <a href="#products" className="shop-button">
              Shop Now
            </a>
          </div>
        </section>

        <section className="products-section" id="products">
          <div className="section-heading">
            <div>
              <p className="section-label">OUR COLLECTION</p>
              <h2>Featured Products</h2>
            </div>

            <p className="product-count">
              {products.length} products
            </p>
          </div>

          {loading && (
            <div className="message">
              Loading products...
            </div>
          )}

          {error && (
            <div className="message error">
              {error}
            </div>
          )}

          {!loading && !error && products.length === 0 && (
            <div className="message">
              No products available.
            </div>
          )}

          {!loading && !error && products.length > 0 && (
            <div className="product-grid">
              {products.map((product) => (
                <article className="product-card" key={product.id}>
                  <div className="product-image">
                    <span>Product</span>
                  </div>

                  <div className="product-info">
                    <h3>{product.name}</h3>

                    <p className="description">
                      {product.description}
                    </p>

                    <div className="product-bottom">
                      <span className="price">
                        ₹{Number(product.price).toLocaleString("en-IN")}
                      </span>

                      <span className="stock">
                        {product.stock > 0
                          ? `${product.stock} available`
                          : "Out of stock"}
                      </span>
                    </div>

                    <button
                      className="add-button"
                      disabled={product.stock <= 0}
                    >
                      {product.stock > 0
                        ? "Add to Cart"
                        : "Out of Stock"}
                    </button>
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>

        <section className="about-section" id="about">
          <p className="section-label">ABOUT SHOPNEST</p>

          <h2>
            A simple e-commerce application
            built for a production-style AWS architecture.
          </h2>

          <p>
            ShopNest is powered by React, Node.js, Express,
            and MySQL and is designed to be deployed using
            a highly available AWS architecture.
          </p>
        </section>
      </main>

      <footer>
        <p>© 2026 ShopNest. Built with React, Node.js & MySQL.</p>
      </footer>
    </div>
  );
}

export default App;
