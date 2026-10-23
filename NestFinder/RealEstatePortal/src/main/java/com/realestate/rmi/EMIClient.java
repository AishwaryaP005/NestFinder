package com.realestate.rmi;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import emi.EMIService;



public class EMIClient {

    public static double getEMI(double loan, double rate, int tenure) {

        try {
            Registry registry = LocateRegistry.getRegistry("localhost", 1099);

            EMIService service = (EMIService) registry.lookup("EMIService");

            return service.calculateEMI(loan, rate, tenure);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}