package emi;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class EMIServer {

    public static void main(String[] args) {

        try {
            EMIImpl obj = new EMIImpl();

            Registry registry = LocateRegistry.createRegistry(1099);

            registry.rebind("EMIService", obj);

            System.out.println("EMI RMI Server Started...");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}