const fs = require("fs").promises;
const json = require(`./${process.argv[2]}`);
const target = json.character.attribs;

const stats = [
  "npc_name",
  "npc_type",
  "npc_ac",
  "hp",
  "npc_hpformula",
  "npc_speed",
  "strength",
  "strength_mod",
  "dexterity",
  "dexterity_mod",
  "constitution",
  "constitution_mod",
  "intelligence",
  "intelligence_mod",
  "wisdom",
  "wisdom_mod",
  "charisma",
  "charisma_mod",
  "npc_resistances",
  "npc_immunities",
  "npc_condition_immunities",
  "npc_senses",
  "npc_languages",
  "npc_challenge",
  "npc_xp",
  "pb",
];

const skills = [
  "npc_acrobatics",
  "npc_animal_handling",
  "npc_arcana",
  "npc_athletics",
  "npc_deception",
  "npc_history",
  "npc_insight",
  "npc_intimidation",
  "npc_investigation",
  "npc_medicine",
  "npc_nature",
  "npc_perception",
  "npc_performance",
  "npc_persuasion",
  "npc_religion",
  "npc_sleight_of_hand",
  "npc_stealth",
  "npc_survival",
];

const attributeSaves = [
  "npc_str_save",
  "npc_dex_save",
  "npc_con_save",
  "npc_int_save",
  "npc_wis_save",
  "npc_cha_save",
];

function statsGetter() {
  let arr = [];
  stats.forEach((item) => {
    let find = target.find(({ name }) => name === item);
    if (find) {
      arr.push({
        [find.name]: find.current,
      });
    }
  });
  return arr;
}

function savesGetter() {
  let arr = [];
  attributeSaves.forEach((item) => {
    let find = target.find(({ name }) => name === item);
    if (find.current !== "") {
      let name = find.name[4].toUpperCase() + find.name.slice(5, 7);
      let value =
        find.current < 0 ? ` -${find.current}, ` : ` +${find.current}, `;
      arr.push(name + value);
    }
  });
  return arr.join("");
}

function skillsGetter() {
  let arr = [];
  skills.forEach((item) => {
    let find = target.find(({ name }) => name === item);
    if (find.current !== "") {
      let name = find.name[4].toUpperCase() + find.name.slice(5);
      let value =
        find.current < 0 ? ` -${find.current}, ` : ` +${find.current}, `;
      arr.push(name + value);
    }
  });
  return arr.join("");
}

function featuresGetter() {
  let prefix = "repeating_npctrait_";
  let find = target.filter((object) => object.name.includes(prefix));

  let idArr = [];
  find.forEach((object) => {
    let id = object.name.split("_");
    if (idArr.includes(id[2]) === false) {
      idArr.push(id[2]);
    }
  });
  let featuresArr = [];
  idArr.forEach((item) => {
    let featureName = target.find(
      ({ name }) => name === `${prefix}${item}_name`
    ).current;
    let featureDesc = target.find(
      ({ name }) => name === `${prefix}${item}_description`
    ).current;
    if (!featureDesc) {
      featureDesc = target.find(
        ({ name }) => name === `${prefix}${item}_desc`
      ).current;
    }
    featuresArr.push({
      feature_name: featureName,
      feature_description: featureDesc,
    });
  });
  return featuresArr;
}

function actionsGetter() {
  let prefix = "repeating_npcaction_";
  let find = target.filter((object) => object.name.includes(prefix));

  let idArr = [];
  find.forEach((object) => {
    let id = object.name.split("_");
    if (idArr.includes(id[2]) === false) {
      idArr.push(id[2]);
    }
  });
  let actionsArr = [];
  idArr.forEach((item) => {
    let actionName = target.find(
      ({ name }) => name === `${prefix}${item}_name`
    ).current;
    let actionToHit = target.find(
      ({ name }) => name === `${prefix}${item}_attack_tohitrange`
    ).current;
    let actionDamage = target.find(
      ({ name }) => name === `${prefix}${item}_attack_onhit`
    ).current;
    let actionDesc = target.find(
      ({ name }) => name === `${prefix}${item}_description`
    );
    let actionDescription = actionDesc ? actionDesc.current : "";
    actionsArr.push({
      action_name: actionName,
      action_tohit: actionToHit,
      action_onhit: actionDamage,
      action_desc: actionDescription,
    });
  });
  return actionsArr;
}

function collater() {
  const stats = statsGetter();
  stats.push({ npc_save_proficiencies: savesGetter() });
  stats.push({ npc_skill_proficiencies: skillsGetter() });
  stats.push({ npc_features: featuresGetter() });
  stats.push({ npc_actions: actionsGetter() });

  return Object.assign({}, ...stats);
}

function fileWriter() {
  let fileName = `${process.argv[2].split(".")[0]}_extracted.json`;
  let fileData = JSON.stringify(collater(), null, 2);
  fs.writeFile(fileName, fileData);
}
fileWriter()
