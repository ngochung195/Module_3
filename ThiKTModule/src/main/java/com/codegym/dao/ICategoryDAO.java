package com.codegym.dao;

import com.codegym.model.Category;

import java.util.List;

public interface ICategoryDAO {
    List<Category> findAll();
    Category findById(int id);
}
