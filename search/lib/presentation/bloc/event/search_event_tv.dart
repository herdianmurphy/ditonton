part of '../search_bloc_tv.dart';

abstract class SearchEventTv extends Equatable {
  const SearchEventTv();

  @override
  List<Object> get props => [];
}

class OnQueryChangedTv extends SearchEventTv {
  final String query;

  OnQueryChangedTv(this.query);

  @override
  List<Object> get props => [query];
}