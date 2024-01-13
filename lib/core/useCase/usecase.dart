abstract class UseCase<T,P>{//t => noe bazgashti/barmigardone ////p=>daryaft
  Future<T> call(P param);
}