get roles assigned to particular SA

gcpgiamp $PR   --flatten="bindings[].members"  --format="table(bindings.role)" --filter="bindings.members:serviceAccount:$sa"
