package emi;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface EMIService extends Remote {
    double calculateEMI(double loanAmount, double rate, int tenure) throws RemoteException;
}