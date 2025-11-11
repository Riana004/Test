package test;

import annotations.Controller;
import annotations.TestAnnotation;
import retour.ModelView;

@Controller("/user")
public class UserController {
    
    @TestAnnotation("/profile")
    public ModelView getUserProfile() {
        ModelView modelView = new ModelView("user-profile.jsp");
        
        // Ajouter des données
        modelView.addObject("username", "JohnDoe");
        modelView.addObject("email", "john@example.com");
        modelView.addObject("age", 30);
        modelView.addObject("isActive", true);
        
        return modelView;
    }
    
    @TestAnnotation("/list")
    public ModelView getUserList() {
        ModelView modelView = new ModelView("user-list.jsp");
        
        // Simuler une liste d'utilisateurs
        java.util.List<String> users = java.util.Arrays.asList("Alice", "Bob", "Charlie");
        modelView.addObject("users", users);
        modelView.addObject("pageTitle", "Liste des utilisateurs");
        
        return modelView;
    }
}