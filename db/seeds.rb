FinancialInstitution.create!([
  {name: "Monotto Example Bank", location: "Atlanta, Ga", core: "777-777-7777", web: "http://www.monotto.com", mobile: "777-777-7777", notes: "Sample notes", relationship_manager: "Dalton Cole", max_transfer_amount: "70.0", transfers_active: true, vendor_id: nil},
  {name: "Monotto Example Bank", location: "Atlanta, Ga", core: "777-777-7777", web: "http://www.monotto.com", mobile: "777-777-7777", notes: "Sample notes", relationship_manager: "Dalton Cole", max_transfer_amount: "70.0", transfers_active: true, vendor_id: nil}
])
HistoricalSnapshotStat.create!([
  {financial_institution_id: 1, thirty_day_savings: "0.0"},
  {financial_institution_id: 2, thirty_day_savings: "0.0"}
])
User.create!([
  {financial_institution_id: 2, bank_user_id: "ADSFASDFKGDSF_ASDFASDF", default_savings_account_identifier: "ASDFASDGSDFGSDFGS", checking_account_identifier: "ASDFASDFASDGDFG", transfers_active: true, safety_net_active: true, max_transfer_amount: "30.0"}
])
Vendor.create!([
  {name: nil, location: nil, core: nil, web: nil, mobile: nil, email: nil, notes: nil, relationship_manager: nil, password_digest: nil, token: nil, token_created_at: nil, public_key: nil}
])
XrefGoalType.create!([
  {code: "CAR", name: "Car Goal", department: nil, financial_institution_id: 1},
  {code: "HOUSE", name: "House Goal", department: nil, financial_institution_id: 1},
  {code: "VACA", name: "Vacation Goal", department: nil, financial_institution_id: 1},
  {code: "OTHER", name: "Other Goal", department: nil, financial_institution_id: 1},
  {code: "TOTSVGS", name: "Total Savings", department: nil, financial_institution_id: 1},
  {code: "CAR", name: "Car Goal", department: nil, financial_institution_id: 2},
  {code: "HOUSE", name: "House Goal", department: nil, financial_institution_id: 2},
  {code: "VACA", name: "Vacation Goal", department: nil, financial_institution_id: 2},
  {code: "OTHER", name: "Other Goal", department: nil, financial_institution_id: 2},
  {code: "TOTSVGS", name: "Total Savings", department: nil, financial_institution_id: 2}
])
XrefGoalTypeStat.create!([
  {xref_goal_type_id: 1, total_num_of_goals: 0},
  {xref_goal_type_id: 2, total_num_of_goals: 0},
  {xref_goal_type_id: 3, total_num_of_goals: 0},
  {xref_goal_type_id: 4, total_num_of_goals: 0},
  {xref_goal_type_id: 5, total_num_of_goals: 0},
  {xref_goal_type_id: 6, total_num_of_goals: 0},
  {xref_goal_type_id: 7, total_num_of_goals: 0},
  {xref_goal_type_id: 8, total_num_of_goals: 0},
  {xref_goal_type_id: 9, total_num_of_goals: 0},
  {xref_goal_type_id: 10, total_num_of_goals: 0}
])
