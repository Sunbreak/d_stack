package com.tal.d_stack;

import android.content.Context;
import android.content.Intent;
import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/*package*/ class DNode implements Parcelable {
    public final String identifier;
    public final String routeName;

    public DNode(String identifier, String routeName) {
        this.identifier = identifier;
        this.routeName = routeName;
    }

    protected DNode(Parcel in) {
        identifier = in.readString();
        routeName = in.readString();
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
    }
}

/*package*/ class DNavigationManager {
    private DNavigationManager() {
    }

    private interface Holder {
        DNavigationManager instance = new DNavigationManager();
    }

    public static DNavigationManager getInstance() {
        return DNavigationManager.Holder.instance;
    }

    private Context appContext;

    private final List<List<DNode>> nodeGroups = new ArrayList<>();

    public void init(Context context) {
        appContext = context.getApplicationContext();
    }

    public void pushRoute(String routeName) {
        DNode node = new DNode(UUID.randomUUID().toString(), routeName);
        putNodeIfAbsent(node);

        // TODO push native page
        Intent intent = DFlutterActivity.withCachedEngineD(DStack.ENGINE_ID).setNode(node).build(appContext);
        appContext.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
    }

    public Optional<List<DNode>> findLastGroup(DNode node) {
        // TODO reverse
        return nodeGroups.stream().filter(group -> {
            return group.stream().anyMatch(n -> n.identifier == node.identifier);
        }).findFirst();
    }

    private void putNodeIfAbsent(DNode node) {
        Optional<List<DNode>> lastGroup = findLastGroup(node);
        if (lastGroup.isPresent()) return;

        // TODO native type
        if (nodeGroups.isEmpty()) {
            nodeGroups.add(Arrays.asList(node));
        } else {
            nodeGroups.get(nodeGroups.size() - 1).add(node);
        }
    }
}
