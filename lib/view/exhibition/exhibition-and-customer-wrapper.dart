import 'customer-wrapper.dart';
import 'exhibition-wrapper.dart';

class ExhibitionAndCustomerWrapper {
  ExhibitionWrapper? exhibitionWrapper;
  CustomerWrapper? customerWrapper;

  ExhibitionAndCustomerWrapper({
    this.exhibitionWrapper,
    this.customerWrapper
  });

  ExhibitionAndCustomerWrapper copy({
    ExhibitionWrapper? exhibitionWrapper,
    CustomerWrapper? customerWrapper
  }) {
    return ExhibitionAndCustomerWrapper(
      exhibitionWrapper: exhibitionWrapper ?? this.exhibitionWrapper,
      customerWrapper: customerWrapper ?? this.customerWrapper
    );
  }
}