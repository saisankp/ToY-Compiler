import java.util.Hashtable;

public class Struct {
    
    public String name;
    Hashtable <String, String> declarations;
    @SuppressWarnings("unchecked")
    public Struct(String name, Hashtable<String, String> declarations) {
        this.name = name;
        this.declarations = (Hashtable)declarations.clone();
    }

    @Override
    public String toString() {
        return "Name: "  + name + ", Declarations: " + declarations;
    }
    
}
