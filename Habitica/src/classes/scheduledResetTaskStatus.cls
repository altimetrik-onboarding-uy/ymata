global class scheduledResetTaskStatus implements Schedulable {
    global void execute(SchedulableContext SC) {
        BatchResetTaskStatus b = new BatchResetTaskStatus();
        database.executebatch(b,150);
    }
}