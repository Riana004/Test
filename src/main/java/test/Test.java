package test;
import annotations.Controller;
import annotations.TestAnnotation;

@Controller
public class Test {
    @TestAnnotation("/test")
    public void testMethod() {
        
    }
}
