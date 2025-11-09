package test;
import annotations.Controller;
import annotations.TestAnnotation;

@Controller
public class TestController {
    @TestAnnotation("/ranto")
    public void ranto() {

    }
    @TestAnnotation("/dylan")
    public void dylan() {
        
    }
    @TestAnnotation("/randy")
    public void randy() {
        
    }
}
