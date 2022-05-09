import java.io.*;
import java.lang.reflect.Array;
import java.util.*;
public class SymbolTable {

    public static Hashtable<String, String> declarations;
    public static Hashtable<String, String> assignments;
    public static ArrayList<Struct> structsDeclared;
    public static HashSet<String> functionsDeclared;
    public static boolean atleastOneMain;

    SymbolTable(){
        assignments = new Hashtable<>(); 
        declarations = new Hashtable<>(); 
        structsDeclared = new ArrayList<>();
        functionsDeclared = new HashSet<>();
    }

    public static void assignmentMade(String variableName, String equalTo){
        //Now, a new assignment is made such as 'a=1;'
        //We need to check a few things.
        //1. Has 'a' been declared before?
        if(!declarations.containsKey(variableName)){
            //ASSIGNMENT USING NON DECLARED VARIABLE ERROR
            System.out.println("ERROR");
            System.exit(0);
        }
        //2.If 'a' has been declared, does 'equalTo' have the same type as 'a' when it was declared?
        String typeOfDeclaration = declarations.get(variableName);
        if(!typeOfDeclaration.equals(equalTo)){
            //You can still set bool x as 0 (integer), so that is an exception we must cover.
            if((!(typeOfDeclaration.equals("Boolean") && equalTo.equals("Integer")))){
                //ASSIGNMENT USING DIFFERENT TYPE THAN USED IN DECLARATION SINCE NOW IT'S " + typeOfDeclaration + "INSTEAD OF " + equalTo
                System.out.println("ERROR");
                System.exit(0);
            }
        }
        assignments.put(variableName, equalTo);
    }


    public static void declarationMade(String variableName, String type){
        //Now, a new declaration is being made such as 'int a;'
        //We need to check a few things.
        //1. Has the variable name been declared before?
        if(declarations.containsKey(variableName)){
            //REDECLARATION ERROR
            System.out.println("ERROR");
            System.exit(0);
        }
        //2. If the variable declared is a struct, has the struct actually been declared before?
        if(!type.equals("Integer") && !type.equals("Boolean") && !type.equals("String")){
            if(!structNameDeclaredBefore(type)){
                //STRUCT USED AS TYPE IN METHOD BUT STRUCT NOT FOUND ERROR
                System.out.println("ERROR");
                System.exit(0);
            }
        }
        declarations.put(variableName, type);
    }

    public static void structDeclared(String structName, Hashtable<String,String> structDeclarations){
        //A new struct has been declared. We need to check a few things before it is declared.
        //1. Has the variable name of the struct been used before as a struct or variable?
        if(declarations.containsKey(structName)){
            //STRUCT NAME HAS BEEN USED BEFORE FOR VARIABLE ERROR
            System.out.println("ERROR");
            System.exit(0);
        }

        if(structNameDeclaredBefore(structName)){
            //STRUCT NAME HAS BEEN USED BEFORE FOR ANOTHER STRUCT ERROR
            System.out.println("ERROR");
            System.exit(0);
        }

        //2. If there are declarations inside the struct to other structs, that struct has to be declared already and it cannot be itself
        Enumeration<String> e = structDeclarations.keys();
        while (e.hasMoreElements()) {
            //Getting the key of a particular entry
            String key = e.nextElement();
            if(!structDeclarations.get(key).equals("Boolean") && !structDeclarations.get(key).equals("String") && !structDeclarations.get(key).equals("Integer")){
                if(!structNameDeclaredBefore(structDeclarations.get(key))){
                    //STRUCT CONTAINS DECLARATION INSIDE IT TO UNKNOWN STRUCT OR TO ITSELF
                    System.out.println("ERROR");
                    System.exit(0);
                }
            }
        }
        Struct newStruct = new Struct(structName, structDeclarations);
        structsDeclared.add(newStruct);
    }

    public static void accessingStructVariableReference(ArrayList<String> structReferencing, String typeOfRHS){
        //An new assignment has been done with accessing a struct that has been declared such as 'Employee em1;'
	    //Now we are accessing em1.name.first_name = RHS, where RHS is the right hand side of the assignment.
        //We need to do some checks before we can complete this assignment

        //1. Does the value on the LHS exist?

        //Check if the first value before the first dot is a variable of a struct declared before (i.e. em1 for the example above)
        if(!declarations.containsKey(structReferencing.get(structReferencing.size()-1))){
            //BAD STRUCT USAGE WITH UNKNOWN STRUCT
            System.out.println("ERROR");
            System.exit(0);
        }

        Struct currentStruct = null;
        String currentStructName = "";

        Enumeration<String> a = declarations.keys();
        while (a.hasMoreElements()) {
            //Getting the key of a particular entry
            String key = a.nextElement();
            if(key.equals(structReferencing.get(structReferencing.size()-1))){
                currentStructName = declarations.get(key);
                break;
            }
        }

        for(int i=0; i<structsDeclared.size(); i++){
            Struct structBeingChecked = structsDeclared.get(i);
            if(structBeingChecked.name.equals(currentStructName)){
                currentStruct = structBeingChecked;
            }
        }

        String lastStructName = "";

        //Now currentStruct will be the struct to the left hand side of the first dot (i.e. em1 in the example above)
        String finalType = "";
        for(int i=-2; i>(-1*structReferencing.size()-1); i--){
           if(lastStructName.equals(currentStruct.name)){
               //ERROR WITH SEEING INSIDE SAME STRUCT
                System.out.println("ERROR");
                System.exit(0);
           }
           lastStructName = currentStruct.name;
           //check structsDeclared for struct with name of Employee and declaration having variable name of structReferencing.get(structReferencing.size()+i
           for(int j=0; j<structsDeclared.size(); j++){
               Struct structWeAreOn = structsDeclared.get(j);
               if(structWeAreOn.name.equals(currentStruct.name)){
                   Iterator<Map.Entry<String, String>> itr = structWeAreOn.declarations.entrySet().iterator();
                    Map.Entry<String, String> entry = null;
                    boolean done = false;
                    while(itr.hasNext()){
                        entry = itr.next();
                        if(entry.getKey().equals(structReferencing.get(structReferencing.size()+i))){
                            //If both above is Name, then we set the current Struct as the struct in structsDeclared with name from above.
                            for(int z = 0; z<structsDeclared.size(); z++){
                                if(structsDeclared.get(z).name.equals(entry.getValue())){
                                    currentStruct = structsDeclared.get(z);
                                    break;
                                }
                                finalType = entry.getValue();
                            } 
                        }
                        if(entry.getKey().equals(structReferencing.get(structReferencing.size()+i))){
                            done = true;
                        }
                    }
                    if(!done){
                        //BAD STRUCT USAGE WITH HAVING A DOT AND A UNKNOWN VARIABLE AFTER
                        System.out.println("ERROR");
                        System.exit(0);
                    }
               }
           }        
        }
        if(!finalType.equals(typeOfRHS)){
            //BAD STRUCT USAGE WITH LHS NOT SAME AS RHS IN EXPRESSION
            System.out.println("ERROR");
            System.exit(0);
        }
    }

    public static Boolean structNameDeclaredBefore(String name){
        boolean answer = false;
        for(int i=0; i<structsDeclared.size(); i++){
            Struct currentStruct = structsDeclared.get(i);
            if(currentStruct.name.equals(name)){
               answer = true;
               break;
            }
        }
        return answer;
    }

    public static void newFunction(String functionName){
        assignments = new Hashtable<>();
        declarations = new Hashtable<>();
        if(functionName.equals("main")){
            atleastOneMain = true;
        }
        if(functionsDeclared.contains(functionName) || !atleastOneMain){
            //FUNCTION HAS BEEN REDECLARED OR NO MAIN
            System.out.println("ERROR");
            System.exit(0);
        }
        functionsDeclared.add(functionName);
    }

    public static void checkReturnType(String declaredReturnType, Boolean returnIncluded, String actualReturnType){
        if(declaredReturnType.equals("Void") && returnIncluded){
            //SHOULDN'T RETURN ANY VALUE FOR VOID FUNCTION
            System.out.println("ERROR");
            System.exit(0);
        }
        else if(!returnIncluded && declaredReturnType.equals("Void")){
            return;
        }
        else{
            if(!declaredReturnType.equals(actualReturnType) && !( declaredReturnType.equals("Boolean") && actualReturnType.equals("Integer"))){
               //"RETURN TYPE" + actualReturnType + "INCORRECT FOR FUNCTIONS " + declaredReturnType
               System.out.println("ERROR");
               System.exit(0);
            }
            if(!actualReturnType.equals("Integer") && !actualReturnType.equals("Boolean") && !actualReturnType.equals("String")){
                //Return type is a struct
                if(!structNameDeclaredBefore(actualReturnType)){
                    //RETURN TYPE IS A STRUCT THAT IS NOT DECLARED BEFORE
                    System.out.println("ERROR");
                    System.exit(0);
                }
            }
        }
        assignments = new Hashtable<>();
        declarations = new Hashtable<>();
    }
}