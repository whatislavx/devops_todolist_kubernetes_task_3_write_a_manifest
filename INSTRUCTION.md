# INSTRUCTION.md: Розгортання та Тестування TodoApp у Kubernetes

Цей посібник містить кроки для розгортання та тестування програми **TodoApp** у кластері **Kubernetes** за допомогою наданих маніфестів.

---

## 1. Огляд Маніфестів

Усі необхідні конфігураційні файли розташовані у каталозі `.infrastructure/`: `namespace.yml` (Namespace `todoapp`), `todoapp-pod.yml` (Pod `todoapp-pod`, порт **8080**, health endpoints) та `busybox-curl.yml` (Pod `busyboxplus-curl` для тестування).

---

## 2. Застосування Ресурсів

Застосуйте всі маніфести у вказаній послідовності:
```bash
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/todoapp-pod.yml
kubectl apply -f .infrastructure/busybox-curl.yml
```
## 3. Перевірка Розгортання
Переконайтеся, що namespace створено, а поди запущені та знаходяться у стані Running.

Bash
```bash
kubectl get ns | findstr todoapp
kubectl get pods -n todoapp
```
Очікуйте, що обидва поди (todoapp-pod та busyboxplus-curl) будуть у стані Running.

4. Локальне Тестування (Port-forward)
Виконайте Port-forward, щоб отримати доступ до todoapp-pod з вашого локального комп'ютера, форвардячи локальний порт 8000 на контейнерний порт 8080:

Bash
```bash
kubectl port-forward pod/todoapp-pod 8000:8080 -n todoapp
```
Залиште цю команду працювати у поточному терміналі. Перевірте Health Endpoints у браузері або curl:

http://localhost:8000/health/liveness/ → Очікувана відповідь: OK

http://localhost:8000/health/readiness/ → Очікувана відповідь: OK

Щоб зупинити Port-forward, натисніть Ctrl+C.

5. Тестування Зв'язку Всередині Кластера (busyboxplus:curl)
Використовуйте busyboxplus-curl pod для тестування мережевого з'єднання з todoapp-pod в межах кластера. Спочатку запустіть інтерактивну оболонку:

Bash
```bash
kubectl exec -it busyboxplus-curl -n todoapp -- sh
```
Потім виконайте curl запити, використовуючи ім'я пода todoapp-pod та його контейнерний порт 8080:

Bash
```bash
curl http://todoapp-pod:8080/health/liveness/
curl http://todoapp-pod:8080/health/readiness/
```
Очікувано, ви отримаєте відповіді: OK. Вийдіть з оболонки: exit.

6. Швидка Діагностика
Для детального аналізу стану пода та логів використовуйте:

Bash
```bash
kubectl describe pod todoapp-pod -n todoapp
kubectl logs todoapp-pod -n todoapp
```
Якщо DNS не працює, перевірте роздільну здатність імен:

Bash
```bash
kubectl exec busyboxplus-curl -n todoapp -- nslookup todoapp-pod
```
7. Прибирання Ресурсів
Видаліть створені ресурси, використовуючи маніфести:

Bash
```bash
kubectl delete -f .infrastructure/busybox-curl.yml
kubectl delete -f .infrastructure/todoapp-pod.yml
kubectl delete -f .infrastructure/namespace.yml
```
