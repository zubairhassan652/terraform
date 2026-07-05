while ($true) {
     Clear-Host
     Write-Host "=== KEDA Monitor ===" -ForegroundColor Cyan

     Write-Host "`n[ScaledObject]" -ForegroundColor Yellow
     kubectl get scaledobject -n argocd

     Write-Host "`n[Worker Pods]" -ForegroundColor Yellow
     kubectl get pods -n argocd | findstr worker

     Write-Host "`n[Queue Length]" -ForegroundColor Yellow
     $q = kubectl exec -n argocd deployment/redis-redis -- redis-cli llen celery
     Write-Host "celery queue: $q tasks"

     Start-Sleep -Seconds 5
 }