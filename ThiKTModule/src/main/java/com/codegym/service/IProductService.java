package com.codegym.service;

import com.codegym.model.Product;

import java.util.List;

public interface IProductService {
    List<Product> findAll();
    Product findById(int id);
    boolean save(Product product);
    boolean update(Product product);
    boolean delete(int id);
    List<Product> search(String name, Double price, Integer categoryId);
}
