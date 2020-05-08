/*
 * Copyright 2019-2020 Hans-Kristian Arntzen for Valve Corporation
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 */

#include "opcodes/opcodes.hpp"
#include "dxil_common.hpp"
#include "opcodes/converter_impl.hpp"
#include "spirv_module.hpp"

namespace dxil_spv
{
bool emit_trace_ray_instruction(Converter::Impl &, const llvm::CallInst *)
{
	// TODO. Dummy here to test RayGen resource declaration for now.
	return true;
}

bool emit_ray_tracing_builtin_load_instruction(Converter::Impl &impl, const llvm::CallInst *inst,
                                               spv::BuiltIn builtin, spv::Id scalar_type)
{
	auto &builder = impl.builder();
	spv::Id input = impl.spirv_module.get_builtin_shader_input(builtin);

	auto *access_chain = impl.allocate(spv::OpAccessChain, builder.makePointer(spv::StorageClassInput, scalar_type));
	access_chain->add_id(input);
	access_chain->add_id(impl.get_id_for_value(inst->getOperand(1), 32));
	impl.add(access_chain);

	auto *load = impl.allocate(spv::OpLoad, inst);
	load->add_id(access_chain->id);
	impl.add(load);
	return true;
}

bool emit_dispatch_rays_index_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInLaunchIdKHR,
	                                                 impl.builder().makeUintType(32));
}

bool emit_dispatch_rays_dimensions_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInLaunchSizeKHR,
	                                                 impl.builder().makeUintType(32));
}

bool emit_object_ray_origin_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInObjectRayOriginKHR,
	                                                 impl.builder().makeFloatType(32));
}

bool emit_world_ray_origin_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInWorldRayOriginKHR,
	                                                 impl.builder().makeFloatType(32));
}

bool emit_object_ray_direction_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInObjectRayDirectionKHR,
	                                                 impl.builder().makeFloatType(32));
}

bool emit_world_ray_direction_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_builtin_load_instruction(impl, inst, spv::BuiltInWorldRayDirectionKHR,
	                                                 impl.builder().makeFloatType(32));
}

bool emit_ray_t_min_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	spv::Id id = impl.spirv_module.get_builtin_shader_input(spv::BuiltInRayTminKHR);
	auto *op = impl.allocate(spv::OpLoad, inst);
	op->add_id(id);
	impl.add(op);
	return true;
}

bool emit_ray_t_current_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	spv::Id id = impl.spirv_module.get_builtin_shader_input(spv::BuiltInRayTmaxKHR);
	auto *op = impl.allocate(spv::OpLoad, inst);
	op->add_id(id);
	impl.add(op);
	return true;
}

static bool emit_ray_tracing_matrix_load(Converter::Impl &impl, const llvm::CallInst *inst, spv::BuiltIn builtin)
{
	auto &builder = impl.builder();
	spv::Id matrix_id = impl.spirv_module.get_builtin_shader_input(builtin);
	auto *chain_op = impl.allocate(spv::OpAccessChain, builder.makePointer(spv::StorageClassInput, builder.makeFloatType(32)));
	chain_op->add_id(matrix_id);

	// Transpose here.
	chain_op->add_id(impl.get_id_for_value(inst->getOperand(2), 32));
	chain_op->add_id(impl.get_id_for_value(inst->getOperand(1)));

	impl.add(chain_op);

	auto *load_op = impl.allocate(spv::OpLoad, inst);
	load_op->add_id(chain_op->id);
	impl.add(load_op);
	return true;
}

bool emit_world_to_object_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_matrix_load(impl, inst, spv::BuiltInWorldToObjectKHR);
}

bool emit_object_to_world_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	return emit_ray_tracing_matrix_load(impl, inst, spv::BuiltInObjectToWorldKHR);
}

bool emit_ray_tracing_instance_id_instruction(Converter::Impl &impl, const llvm::CallInst *inst)
{
	spv::Id index_id = impl.spirv_module.get_builtin_shader_input(spv::BuiltInInstanceCustomIndexKHR);
	auto *op = impl.allocate(spv::OpLoad, inst);
	op->add_id(index_id);
	impl.add(op);
	return true;
}
}