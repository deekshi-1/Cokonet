public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Ubuntu! Java is running.");
        String version = System.getProperty("java.version");
        System.out.println("Running on Java version: " + version);
    }
}