%{
  id: Module,
  type: :worker # or :supervisor
  start: {:Module, :start_link, []}
}
