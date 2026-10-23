package emi;

import java.rmi.server.UnicastRemoteObject;
import java.rmi.RemoteException;

public class EMIImpl extends UnicastRemoteObject implements EMIService {

    public EMIImpl() throws RemoteException {
        super();
    }

    @Override
    public double calculateEMI(double loanAmount, double rate, int tenure) throws RemoteException {

        double monthlyRate = rate / (12 * 100);

        double emi = (loanAmount * monthlyRate * Math.pow(1 + monthlyRate, tenure)) /
                     (Math.pow(1 + monthlyRate, tenure) - 1);

        return emi;
    }
}