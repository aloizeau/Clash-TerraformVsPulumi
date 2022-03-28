output "Current_IP" {
  value = chomp(data.http.currentip.body)
}
