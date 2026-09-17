package com.codegym.dao;

import com.codegym.model.Product;

import java.util.List;

public interface IProductDAO {
    List<Product> findAll();
    Product findById(int id);
    boolean insert(Product product);
    boolean update(Product product);
    boolean delete(int id);
    List<Product> search(String name, Double price, Integer categoryId);
}
