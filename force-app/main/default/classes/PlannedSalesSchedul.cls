public class PlannedSalesSchedul implements Schedulable {
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new PlannedSalesProcessor(), 200);
     }
}