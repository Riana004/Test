package test;
import java.lang.reflect.*;
import annotations.Url;
public class Main {
    public static void main(String[] args) {
        try {
            Class<?> clazz = Class.forName("test.Test");
            Method[] methods = clazz.getDeclaredMethods();
            for (Method method : methods) {
                if (method.isAnnotationPresent(Url.class)) {
                    Url annotation = method.getAnnotation(Url.class);
                    System.out.println("Method: " + method.getName() + ", Annotation Value: " + annotation.value());
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
