every 30.minutes do
  runner "LoanService.check_and_update_expired_loans"
end

every 5.minutes do
  runner "LoanService.test_schedule"
end