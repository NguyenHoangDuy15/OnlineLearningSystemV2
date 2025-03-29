package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class TransactionAdmin {

    private String transactionDate;
    private double totalAmount;

    public TransactionAdmin() {
    }

    public TransactionAdmin(String transactionDate, double totalAmount) {
        this.transactionDate = transactionDate;
        this.totalAmount = totalAmount;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    @Override
    public String toString() {
        return "TransactionAdmin{" + "transactionDate=" + transactionDate + ", totalAmount=" + totalAmount + '}';
    }

}
