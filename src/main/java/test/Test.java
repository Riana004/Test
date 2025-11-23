package test;
import annotations.Controller;
import annotations.Url;

@Controller
public class Test {
    @Url("/test")
    public void testMethod() {
        
    }
}
