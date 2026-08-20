-- Run from a Gen1Recomp checkout with LuaJIT.
package.path = "./?.lua;./?/init.lua;" .. package.path

local T = require("tests.modkit")
local root = os.getenv("TRAINER_CAREER_ROOT")
  or "C:/dev/gen1recomp-trainer-career"

local run = T.sdk.loadMod(root, { generation = 1 })
T.eq(#run.errors, 0,
  "Trainer Career loads cleanly (" .. tostring(run.errors[1]) .. ")")
T.check(run.mod ~= nil, "the loader discovered Trainer Career")
T.eq(run.mod.state, "loaded", "the Gen 1 target is active")

local exported = run.loader.exports.trainer_career
T.check(exported ~= nil, "the scaffold export exists")
T.eq(exported.schemaVersion, 1, "the future state schema starts at version 1")
local status = exported.status()
T.eq(status.phase, 0, "the scaffold reports Phase 0")
T.eq(status.ready, false, "the scaffold does not claim tracking is ready")

run.release()
T.finish("trainer_career scaffold")
