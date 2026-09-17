package com.codegym.service;

import com.codegym.dao.CategoryDAO;
import com.codegym.dao.ICategoryDAO;
import com.codegym.model.Category;

import java.util.List;

public class CategoryService implements ICategoryService {

    private final ICategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    public CategoryService(ICategoryDAO categoryDAO) {
        this.categoryDAO = categoryDAO;
    }

    @Override
    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public Category findById(int id) {
        return categoryDAO.findById(id);
    }
}
