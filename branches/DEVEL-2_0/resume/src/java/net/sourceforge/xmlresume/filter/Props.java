import java.lang.*;
import java.util.*;

class Props {
    public static void main (String argv[]) {

        Properties props = System.getProperties();

        props.list(System.out);

        System.exit(0);
    }
}
