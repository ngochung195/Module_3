package com.codegym.service;

import com.codegym.dao.IProductDAO;
import com.codegym.dao.ProductDAO;
import com.codegym.model.Product;

import java.util.List;

public class ProductService implements IProductService {

    private final IProductDAO productDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
    }

    public ProductService(IProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    @Override
    public List<Product> findAll() {
        return productDAO.findAll();
    }

    @Override
    public Product findById(int id) {
        return productDAO.findById(id);
    }

    @Override
    public boolean save(Product product) {
        return productDAO.insert(product);
    }

    @Override
    public boolean update(Product product) {
        return productDAO.update(product);
    }

    @Override
    public boolean delete(int id) {
        return productDAO.delete(id);
    }

    @Override
    public List<Product> search(String name, Double price, Integer categoryId) {
        return productDAO.search(name, price, categoryId);
    }
}
