import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.dart';

void main() {
  late MockPopularMovieBloc mockPopularMovieBloc;

  setUpAll(() {
    registerFallbackValue(PopularMovieEventFake());
    registerFallbackValue(PopularMovieStateFake());
  });

  setUp(() {
    mockPopularMovieBloc = MockPopularMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularMovieBloc>(
            create: (context) => mockPopularMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovieList = testMovieList;

  group('Popular Movie Page', () {
    testWidgets('Page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockPopularMovieBloc.state).thenReturn(PopularMovieLoading());

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

          expect(progressBarFinder, findsOneWidget);
          expect(centerFinder, findsOneWidget);
        });

    testWidgets('Page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockPopularMovieBloc.state)
              .thenReturn(PopularMovieHasData(tMovieList));

          final listViewFinder = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('Page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockPopularMovieBloc.state)
              .thenReturn(PopularMovieError('Error message'));

          final textFinder = find.text("Error message");
          await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

          expect(textFinder, findsOneWidget);
        });
  });
}
