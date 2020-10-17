class PaymentCard {
  const PaymentCard({
    this.label,
    this.cardHolderName,
    this.paymentDueDate,
    this.statementDate,
    this.limit,
  });

  final String label;
  final String cardHolderName;
  final String paymentDueDate;
  final String statementDate;
  final String limit;
}
