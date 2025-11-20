Маніфести у каталозі `.infrastructure/`:
- `namespace.yml` (Namespace `todoapp`)
- `todoapp-pod.yml` (Pod `todoapp`, порт 8000, health endpoints)
- `busybox-curl.yml` (Pod `busybox-curl` з образом `busyboxplus:curl` або `curlimages/curl`)

## Застосування всіх маніфестів:
```bash
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/todoapp-pod.yml
kubectl apply -f .infrastructure/busybox-curl.yml
```

## Перевірка:
```bash
kubectl get ns | findstr todoapp
kubectl get pods -n todoapp
```

## Port-forward для локального тестування
```bash
kubectl port-forward pod/todoapp 8000:8000 -n todoapp
```
В браузері перевірити:
- http://localhost:8000/health/liveness/ → `OK`
- http://localhost:8000/health/readiness/ → `{"status": "ready"}`

(Ctrl+C щоб зупинити)

## Тест з busyboxplus:curl (у кластері)
```bash
kubectl exec -it busybox-curl -n todoapp -- sh
curl http://todoapp:8000/health/liveness/
curl http://todoapp:8000/health/readiness/
```
Очікувано ті самі відповіді.

Вийти: `exit`

## Швидка діагностика
```bash
kubectl describe pod todoapp -n todoapp
kubectl logs todoapp -n todoapp
```

Якщо DNS не працює:
```bash
kubectl exec busybox-curl -n todoapp -- nslookup todoapp
```

## Прибирання ресурсів
```bash
kubectl delete -f .infrastructure/busybox-curl.yml
kubectl delete -f .infrastructure/todoapp-pod.yml
kubectl delete -f .infrastructure/namespace.yml
```
