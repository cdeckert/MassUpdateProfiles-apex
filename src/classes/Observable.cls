public interface Observable
{
    void notifyObserver(Eventx event);
    void addObservers(List<Observer> observers);
}