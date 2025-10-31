package test;

import java.io.File;
import java.lang.annotation.Annotation;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import annotations.Controller;

public class TestAnnotation {
    public static List<Class<?>> findAnnotatedClasses(String packageName, Class<?> annotation)
            throws Exception {
        List<Class<?>> classes = new ArrayList<>();
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        String path = packageName.replace('.', '/');

        Enumeration<URL> resources = classLoader.getResources(path);

        while (resources.hasMoreElements()) {
            URL resource = resources.nextElement();
            if (resource.getProtocol().equals("file")) {
                classes.addAll(findClassesInDirectory(new File(resource.getFile()), packageName, annotation));
            } else if (resource.getProtocol().equals("jar")) {
                classes.addAll(findClassesInJar(resource, packageName, annotation));
            }
        }

        return classes;
    }

    private static List<Class<?>> findClassesInDirectory(File directory, String packageName, Class<?> annotation)
            throws Exception {
        List<Class<?>> classes = new ArrayList<>();

        if (!directory.exists()) {
            return classes;
        }

        File[] files = directory.listFiles();
        if (files == null)
            return classes;

        for (File file : files) {
            if (file.isDirectory()) {
                classes.addAll(findClassesInDirectory(file, packageName + "." + file.getName(), annotation));
            } else if (file.getName().endsWith(".class")) {
                String className = packageName + '.' + file.getName().substring(0, file.getName().length() - 6);
                Class<?> clazz = Class.forName(className);
                if (clazz.isAnnotationPresent((Class<? extends Annotation>) annotation)) {
                    classes.add(clazz);
                }
            }
        }

        return classes;
    }

    private static List<Class<?>> findClassesInJar(URL jarUrl, String packageName, Class<?> annotation)
            throws Exception {
        List<Class<?>> classes = new ArrayList<>();
        String jarPath = jarUrl.getPath().substring(5, jarUrl.getPath().indexOf("!"));
        JarFile jar = new JarFile(jarPath);
        String packagePath = packageName.replace('.', '/');

        Enumeration<JarEntry> entries = jar.entries();
        while (entries.hasMoreElements()) {
            JarEntry entry = entries.nextElement();
            String entryName = entry.getName();

            if (entryName.endsWith(".class") && entryName.startsWith(packagePath)) {
                String className = entryName.replace('/', '.').substring(0, entryName.length() - 6);
                try {
                    Class<?> clazz = Class.forName(className);
                    if (clazz.isAnnotationPresent((Class<? extends Annotation>) annotation)) {
                        classes.add(clazz);
                    }
                } catch (NoClassDefFoundError | ClassNotFoundException e) {
                    System.err.println("Erreur lors du chargement de la classe " + className + ": " + e.getMessage());
                }
            }
        }
        jar.close();

        return classes;
    }
    public static void main(String[] args) {
        try {
            System.out.println("=== Test du Scanner d'Annotations ===\n");
            
            System.out.println("1. Scan du package 'test':");
            List<Class<?>> controllers = findAnnotatedClasses("test", Controller.class);
            
            if (controllers.isEmpty()) {
                System.out.println("   Aucun contrôleur trouvé dans le package 'test'");
            } else {
                System.out.println("   Contrôleurs trouvés (" + controllers.size() + "):");
                for (Class<?> controller : controllers) {
                    System.out.println("   - " + controller.getName());
                    
                    try {
                        Object instance = controller.getDeclaredConstructor().newInstance();
                        System.out.println("     Instance créée: " + instance);
                    } catch (Exception e) {
                        System.out.println("     Erreur lors de l'instanciation: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("   Erreur lors du scan des annotations: " + e.getMessage());
        }
    }
}
