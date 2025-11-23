package test;
import annotations.Controller;
import annotations.RequestParam;
import annotations.Url;
import retour.ModelView;

@Controller
public class TestController {
    @Url("/ranto")
    public String ranto() {
        return "Bonjour Ranto";
    }
    @Url("/dylan")
    public void dylan() {
        
    }
    @Url("/randy")
    public String randy() {
        return "Bonjour Randy";
    }

    @Url("/test/{id}/info/{name}")
    public String testId(@RequestParam(value = "id", required = true) int caca, String name) {
        return "ID: " + caca + ", Name: " + name;
    }

    @Url("/")
    public ModelView home() {
        ModelView mv = new ModelView("formulaire.html");
        return mv;
    }

    @Url("/test/param")
    public String testParam(@RequestParam(value = "name", required = true) String nom, int age) {
        return "Nom: " + nom + ", Age: " + age;
    }
}
