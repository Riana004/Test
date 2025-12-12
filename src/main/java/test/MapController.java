package test;

import java.util.Map;

import annotations.Controller;
import annotations.PostRequest;
import annotations.RequestParam;
import retour.ModelView;

@Controller("/map")
public class MapController {

    @PostRequest("/capture")
    public String capture(
            @RequestParam(value = "name", required = true) String name,
            int age,
            Map<String, Object> extras) {
        StringBuilder sb = new StringBuilder();
        sb.append("name=").append(name)
          .append(", age=").append(age)
          .append(" | extras=").append(extras);
        return sb.toString();
    }

    @PostRequest("/mv")
    public ModelView captureModelView(
            @RequestParam(value = "title", required = true) String title,
            Map<String, Object> extras) {
        ModelView mv = new ModelView("user-profile.jsp");
        mv.addObject("title", title);
        if (extras != null) {
            Object username = extras.get("username");
            Object email = extras.get("email");
            Object ageStr = extras.get("age");
            Object activeStr = extras.get("isActive");

            if (username != null) {
                mv.addObject("username", username.toString());
            }
            if (email != null) {
                mv.addObject("email", email.toString());
            }
            if (ageStr != null) {
                try {
                    mv.addObject("age", Integer.parseInt(ageStr.toString()));
                } catch (NumberFormatException e) {
                    // ignore invalid age
                }
            }
            if (activeStr != null) {
                mv.addObject("isActive", Boolean.parseBoolean(activeStr.toString()));
            }
        }
        return mv;
    }
}
