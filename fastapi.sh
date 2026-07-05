 while ($true) {
     Clear-Host
     Write-Host "=== FastAPI Autoscaling Monitor ===" -ForegroundColor Cyan
     Write-Host "Time: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray

     Write-Host "`n[HPA Status]" -ForegroundColor Yellow
     kubectl get hpa -n argocd

     Write-Host "`n[FastAPI Pods]" -ForegroundColor Yellow
     kubectl get pods -n argocd | findstr fastapi

     Write-Host "`n[CPU + Memory Usage]" -ForegroundColor Yellow
     kubectl top pods -n argocd | findstr fastapi

     Write-Host "`n[Node Resources]" -ForegroundColor Yellow
     kubectl top node

     Start-Sleep -Seconds 5
 }