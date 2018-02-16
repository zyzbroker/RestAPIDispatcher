public interface IDispatcher {
    RestResult execute(String action, Blob body);
}