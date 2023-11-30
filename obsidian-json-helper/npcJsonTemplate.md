# {{npc_name}}
*{{npc_type}}*
**Armour Class** {{npc_ac}}
**Hit Points** {{hp}} ({{npc_hpformula}})
**Speed** {{npc_speed}}

| STR | DEX | CON | INT | WIS | CHA |
| - | - | - | - | - | - |
| {{strength}}({{strength_mod}}) | {{dexterity}}({{dexterity_mod}}) | {{constitution}}({{constitution_mod}}) | {{intelligence}}({{intelligence_mod}}) | {{wisdom}}({{wisdom_mod}}) | {{charisma}}({{charisma_mod}}) |

**Saving Throws** {{npc_save_proficiencies}}
**Skills** {{npc_skill_proficiencies}}
**Damage Resistances** {{npc_resistances}}
**Damage Immunities** {{npc_immunities}}
**Condition Immunities** {{npc_condition_immunities}}
**Senses** {{npc_senses}}
**Languages** {{npc_languages}}
**Challenge Rating** {{npc_challenge}}
**Proficiency Bonus** {{pb}}
___
## Features
{{#each npc_features}}
**{{feature_name}}**
{{feature_description}}

{{/each}}
___
## Actions
{{#each npc_actions}}
**{{action_name}}** {{action_tohit}} {{action_onhit}} {{action_desc}}

{{/each}}
___
## Inventory
___
## Info

#NPC

