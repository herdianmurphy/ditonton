import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.dart';

void main() {
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMovieEventFake());
    registerFallbackValue(TopRatedMovieStateFake());
  });

  setUp(() {
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedMovieBloc>(
            create: (context) => mockTopRatedMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovieList = testMovieList;

  group('Top Rated Movie Page', () {
    testWidgets('Page should display center progress bar when loading',
            (WidgetTester tester) async {
          when(() => mockTopRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());

          final progressBarFinder = find.byType(CircularProgressIndicator);
          final centerFinder = find.byType(Center);

          await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

          expect(progressBarFinder, findsOneWidget);
          expect(centerFinder, findsOneWidget);
        });

    testWidgets('Page should display ListView when data is loaded',
            (WidgetTester tester) async {
          when(() => mockTopRatedMovieBloc.state)
              .thenReturn(TopRatedMovieHasData(tMovieList));

          final listViewFinder = find.byType(ListView);

          await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

          expect(listViewFinder, findsOneWidget);
        });

    testWidgets('Page should display text with message when Error',
            (WidgetTester tester) async {
          when(() => mockTopRatedMovieBloc.state)
              .thenReturn(TopRatedMovieError('Error message'));

          final textFinder = find.text("Error message");
          await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

          expect(textFinder, findsOneWidget);
        });
  });
}
