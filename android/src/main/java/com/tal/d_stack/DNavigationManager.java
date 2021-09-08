package com.tal.d_stack;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.function.Predicate;

/*package*/ class DNode implements Parcelable {
    public static final int TYPE_FLUTTER = 0;
    public static final int TYPE_NATIVE = 1;

    public final String identifier;
    public final String routeName;
    public final int type;

    public DNode(String identifier, String routeName, int type) {
        this.identifier = identifier;
        this.routeName = routeName;
        this.type = type;
    }

    protected DNode(Parcel in) {
        identifier = in.readString();
        routeName = in.readString();
        type = in.readInt();
    }

    public static final Creator<DNode> CREATOR = new Creator<DNode>() {
        @Override
        public DNode createFromParcel(Parcel in) {
            return new DNode(in);
        }

        @Override
        public DNode[] newArray(int size) {
            return new DNode[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(identifier);
        dest.writeString(routeName);
        dest.writeInt(type);
    }

    public Map<String, Object> toMap() {
        return new HashMap() {{
            put("identifier", identifier);
            put("routeName", routeName);
            put("type", type);
        }};
    }
}

/*package*/ class DNodeGroup {
    public final List<DNode> nodes = new ArrayList<>();
    public final Map<String, Activity> activities = new HashMap<>();
}

/*package*/ class DNavigationManager implements SimpleActivityLifecycleCallbacks {
    private DNavigationManager() {
    }

    private interface Holder {
        DNavigationManager instance = new DNavigationManager();
    }

    public static DNavigationManager getInstance() {
        return DNavigationManager.Holder.instance;
    }

    private Context appContext;

    private final Map<String, DStack.NativeRoute> routeMap = new HashMap<>();

    private final List<DNodeGroup> nodeGroups = new ArrayList<>();

    public void init(Context context) {
        appContext = context.getApplicationContext();
    }

    public void registerRoute(Map<String, DStack.NativeRoute> routeMap) {
        this.routeMap.putAll(routeMap);
    }

    public void pushRoute(String routeName) {
        boolean isNativeRoute = routeMap.containsKey(routeName);
        DNode node = new DNode(UUID.randomUUID().toString(), routeName, isNativeRoute ? DNode.TYPE_NATIVE : DNode.TYPE_FLUTTER);
        addNodeOrGroup(node);

        if (isNativeRoute) {
            // Ensure onActivityCreated/onActivityDestroyed findLastGroup(node)
            Intent intent = routeMap.get(routeName).build(appContext).putExtra(DFlutterActivity.EXTRA_NODE, node);
            appContext.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
        } else {
            DNodeGroup lastGroup = nodeGroups.get(nodeGroups.size() - 1);
            if (lastGroup.activities.isEmpty()) {
                // Ensure onActivityCreated/onActivityDestroyed findLastGroup(node)
                Intent intent = DFlutterActivity.withCachedEngineD(DStack.ENGINE_ID).setNode(node).build(appContext);
                appContext.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
            } else {
                DStackPlugin.getInstance().activateFlutterNode(node);
            }
        }
    }

    @Override
    public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
        if (activity.getIntent().hasExtra(DFlutterActivity.EXTRA_NODE)) {
            // Before created, DNode within activity should be in DNode groups
            DNode node = activity.getIntent().getParcelableExtra(DFlutterActivity.EXTRA_NODE);
            findLastGroup(node).get().activities.put(node.identifier, activity);
        }
    }

    @Override
    public void onActivityDestroyed(@NonNull Activity activity) {
        if (activity.getIntent().hasExtra(DFlutterActivity.EXTRA_NODE)) {
            // Before destroyed, DNode within activity could be removed already
            DNode node = activity.getIntent().getParcelableExtra(DFlutterActivity.EXTRA_NODE);
            findLastGroup(node).ifPresent(group -> {
                group.activities.remove(node.identifier);
                Iterables.removeAll(group.nodes, n -> n.identifier.equals(node.identifier));
            });
            Iterables.removeAll(nodeGroups, g -> g.nodes.isEmpty());
        }
    }

    public DNode findTopNode(DNode node) {
        return findLastGroup(node).map(group -> group.nodes.get(group.nodes.size() - 1)).orElse(null);
    }

    private Optional<DNodeGroup> findLastGroup(DNode node) {
        // TODO reverse
        return nodeGroups.stream().filter(group -> {
            return group.nodes.stream().anyMatch(n -> n.identifier.equals(node.identifier));
        }).findFirst();
    }

    private void addNodeOrGroup(DNode node) {
        if (nodeGroups.isEmpty()) {
            DNodeGroup group = new DNodeGroup();
            group.nodes.add(node);
            nodeGroups.add(group);
        } else {
            DNodeGroup lastGroup = nodeGroups.get(nodeGroups.size() - 1);
            if (lastGroup.nodes.get(0).type == node.type) {
                lastGroup.nodes.add(node);
            } else {
                DNodeGroup group = new DNodeGroup();
                group.nodes.add(node);
                nodeGroups.add(group);
            }
        }
    }
}

/*package*/ interface SimpleActivityLifecycleCallbacks extends Application.ActivityLifecycleCallbacks {
    default void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
    }

    default void onActivityStarted(@NonNull Activity activity) {
    }

    default void onActivityResumed(@NonNull Activity activity) {
    }

    default void onActivityPaused(@NonNull Activity activity) {
    }

    default void onActivityStopped(@NonNull Activity activity) {
    }

    default void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
    }

    default void onActivityDestroyed(@NonNull Activity activity) {
    }
}

/*package*/ interface Iterables {
    static <T> boolean removeAll(Iterable<T> iterable, Predicate<T> predicate) {
        int removeCount = 0;
        Iterator<T> iterator = iterable.iterator();
        while (iterator.hasNext()) {
            T next = iterator.next();
            if (predicate.test(next)) {
                iterator.remove();
                removeCount++;
            }
        }
        return removeCount > 0;
    }
}
