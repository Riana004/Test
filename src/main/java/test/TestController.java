package test;
import annotations.Controller;
import annotations.TestAnnotation;

@Controller
public class TestController {
    @TestAnnotation("/ranto")
    public String ranto() {
        return "Bonjour Ranto";
    }
    @TestAnnotation("/dylan")
    public void dylan() {
        
    }
    @TestAnnotation("/randy")
    public String randy() {
        return "Bonjour Randy";
    }
}
