// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$lastOnResumeCallAtom = Atom(name: '_UserStore.lastOnResumeCall');

  @override
  int get lastOnResumeCall {
    _$lastOnResumeCallAtom.reportRead();
    return super.lastOnResumeCall;
  }

  @override
  set lastOnResumeCall(int value) {
    _$lastOnResumeCallAtom.reportWrite(value, super.lastOnResumeCall, () {
      super.lastOnResumeCall = value;
    });
  }

  final _$fbMessagingAtom = Atom(name: '_UserStore.fbMessaging');

  @override
  FirebaseMessaging get fbMessaging {
    _$fbMessagingAtom.reportRead();
    return super.fbMessaging;
  }

  @override
  set fbMessaging(FirebaseMessaging value) {
    _$fbMessagingAtom.reportWrite(value, super.fbMessaging, () {
      super.fbMessaging = value;
    });
  }

  final _$userAtom = Atom(name: '_UserStore.user');

  @override
  UserEntity get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserEntity value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$statisticAtom = Atom(name: '_UserStore.statistic');

  @override
  StatisticData get statistic {
    _$statisticAtom.reportRead();
    return super.statistic;
  }

  @override
  set statistic(StatisticData value) {
    _$statisticAtom.reportWrite(value, super.statistic, () {
      super.statistic = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_UserStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$orderAtom = Atom(name: '_UserStore.order');

  @override
  OrderData get order {
    _$orderAtom.reportRead();
    return super.order;
  }

  @override
  set order(OrderData value) {
    _$orderAtom.reportWrite(value, super.order, () {
      super.order = value;
    });
  }

  final _$loadCurrentUserAsyncAction =
      AsyncAction('_UserStore.loadCurrentUser');

  @override
  Future<Null> loadCurrentUser() {
    return _$loadCurrentUserAsyncAction.run(() => super.loadCurrentUser());
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  void addOrder(OrderData orderData) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.addOrder');
    try {
      return super.addOrder(orderData);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool loading) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setLoading');
    try {
      return super.setLoading(loading);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUser(UserEntity user) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatisticUser(StatisticData statisticData) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setStatisticUser');
    try {
      return super.setStatisticUser(statisticData);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastOnResumeCall(int last) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setLastOnResumeCall');
    try {
      return super.setLastOnResumeCall(last);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAcceptedOrdersToday() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setAcceptedOrdersToday');
    try {
      return super.setAcceptedOrdersToday();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRejectedOrdersToday() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setRejectedOrdersToday');
    try {
      return super.setRejectedOrdersToday();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeliveredOrdersToday() {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setDeliveredOrdersToday');
    try {
      return super.setDeliveredOrdersToday();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
lastOnResumeCall: ${lastOnResumeCall},
fbMessaging: ${fbMessaging},
user: ${user},
statistic: ${statistic},
isLoading: ${isLoading},
order: ${order}
    ''';
  }
}
