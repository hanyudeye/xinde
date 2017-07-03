import java.util.*;
//import java.util.Date;

public class java 
{
    // public static void main(String [] args)
    // {
    //     // create a new (empty) ArrayList
    //     ArrayList al = new ArrayList();
    //     // fill the ArrayList with args
    //     for(int i = 0; i < args.length; i++) {
    //         al.add(args[i]);
    //     }
    //     // use the iterator in the while loop
    //     Iterator itr1 = al.iterator();
    //     while(itr1.hasNext()) {
    //         String onearg;
    //         onearg = (String) (itr1.next());
    //         System.out.println("arg=" + onearg);
    //     }
    //     // define and use the iterator in the for loop:
    //     for(Iterator itr2 = al.iterator(); itr2.hasNext(); ) {
    //         String onearg;
    //         onearg = (String) (itr2.next());
    //         System.out.println("arg=" + onearg);
    //     }
    // }
    // main

    // public static void main(String [] args)
    // {
    //     // List <String> loa = Arrays.
    //     // asList(args);
    //     // System.out.println("size=" + loa.size());
    //     // for(String str : loa) {
    //     //     System.out.println("arg=" + str);
    //     // }

    // }
    package test;
    public class exam{
        public int chang=23;
    }

    public static void main(String [] args){
        // for(String str: args){
        //         System.out.println("arg="+str);
        //     }
        //        String format = "the %s %s\n"; // 
        //System.out.printf(format, adjective, noun);
        Date today = new Date();
        int hour=today.getHours();
        System.out.println(hour);
    }

}
