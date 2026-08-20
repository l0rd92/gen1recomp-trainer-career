-- Trainer Career entry point. Phase 0 intentionally alters no gameplay.
return function(mod)
  mod.exports.schemaVersion = 1
  mod.exports.status = function()
    return {
      phase = 0,
      ready = false,
      message = "Project scaffold only; tracking is not implemented yet.",
    }
  end
end
