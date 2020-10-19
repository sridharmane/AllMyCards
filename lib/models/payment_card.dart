class PaymentCard {
  PaymentCard({
    this.id,
    this.label,
    this.cardHolderName,
    this.paymentDueDate,
    this.statementDate,
    this.limit,
  });

  String id;
  String label;
  String cardHolderName;
  int paymentDueDate;
  int statementDate;
  String limit;

  factory PaymentCard.fromRow(String id, List<dynamic> row) {
    if (row.length < 5) {
      return null;
    }
    return PaymentCard(
      id: id,
      label: row[0] ?? 'No-Label',
      cardHolderName: row[1] ?? 'No-CardHolder',
      limit: row[2] ?? 'No-Limit',
      paymentDueDate: int.tryParse(row[3]) ?? 0,
      statementDate: int.tryParse(row[4]) ?? 0,
    );
  }

  List<dynamic> toRow() {
    return [label, cardHolderName, limit, paymentDueDate, statementDate];
  }
}
