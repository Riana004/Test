package test;
import annotations.Controller;
import annotations.TestAnnotation;
import retour.ModelView;

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

    @TestAnnotation("/test/{id}/info/{name}")
    public String testId() {
        return "Test ID";
    }

    @TestAnnotation("/")
    public ModelView home() {
        ModelView mv = new ModelView("formulaire.html");
        return mv;
    }

    @TestAnnotation("/test/param")
    public String testParam(String name, int age) {
        return "Nom: " + name + ", Age: " + age;
    }
}
